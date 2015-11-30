CollectionBehaviours.defineBehaviour 'slugify', (getTransform, args) ->
  { attribute, source } = _.defaults (args[0] ?= {}),
    attribute: 'slug'
    source: 'label'
  logmr "Slugify config: #{@_name}.#{attribute} from", source

  create = (userId, doc, fieldNames, modifier, options) =>
    slug = s.slugify if _.isFunction source
      source userId, doc, fieldNames, modifier, options
    else modifier?.$set?[source] ? doc[source] # latest source prefered
    if (not _.isString slug) or _.isEmpty s.trim slug
      slug = new Mongo.Collection.ObjectID().toHexString()
    slug
  sanitize = (maxAlreadyInDb, slug) =>
    query = {}; query[attribute] = slug
    if (count = (@find query).count()) > maxAlreadyInDb # update = 1, insert = 0
      slug = "#{slug}-#{count+1}"
    slug

  @before.insert (userId, doc) =>
    doc.slug = sanitize 0, create userId, doc

  @before.update (userId, doc, fieldNames, modifier, options) =>
    logmr '!!!!!!!!!!', arguments
    isReplacement = do ->
      for own key, value of modifier when s.startsWith key, '$'
        return false
      true
    if isReplacement
      slug = modifier.slug
      if not  _.isEmpty slug
        modifier.slug = sanitize 1, slug
      else if (_.isEmpty slug) or _.isEmpty doc.slug
        modifier.slug = sanitize 1, create userId, doc, fieldNames, modifier, options
    else
      modifier.$set ?= {}
      slug = modifier.$set.slug
      if not  _.isEmpty slug
        # we got a new slug, validate it
        modifier.$set.slug = sanitize 1, slug
        logmr 'slugify checked slug', doc._id, slug, modifier.$set.slug
      else if (_.isEmpty slug) or modifier.$unset?.slug? or _.isEmpty doc.slug
        # slug got cleared - put a new one
        if modifier.$unset?.slug? then delete modifier.$unset.slug
        modifier.$set.slug = sanitize 1, create userId, doc, fieldNames, modifier, options
        logmr 'slugify create new for', doc._id, modifier.$set.slug
    if _.isEmpty modifier.$set then delete modifier.$set
    if _.isEmpty modifier.$unset then delete modifier.$unset
