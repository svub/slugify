Package.describe({
  name: 'svub:slugify',
  version: '0.0.2',
  // Brief, one-line summary of the package.
  summary: 'Adds slugs to your objects when you insert them into MongoDB.',
  // URL to the Git repository containing the source code for this package.
  git: '',
  // By default, Meteor will default to using README.md for documentation.
  // To avoid submitting documentation, set this field to null.
  documentation: 'README.md'
});

Package.onUse(function(api) {
  api.versionsFrom('1.2.1');
  api.use(['coffeescript', 'sewdn:collection-behaviours', 'underscorestring:underscore.string']);
  api.addFiles('slugify.coffee');
});

Package.onTest(function(api) {
  api.use('ecmascript');
  api.use('tinytest');
  api.use('svub:slugify');
  api.addFiles('slugify-tests.js');
});
