var originalLookup = Handlebars.JavaScriptCompiler.prototype.nameLookup;

Handlebars.JavaScriptCompiler.prototype.nameLookup = function(parent, name, type) {
  if (type === 'context') {
    return '"CALLED PATCH"';
  }
  else {
    return originalLookup.call(this, parent, name, type);
  }
};
