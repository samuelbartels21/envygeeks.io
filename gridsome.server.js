const path = require("path");
const config = require("./gridsome.config.js");
const fs = require("fs");

/**
 * @author Jordon Bedwell
 * @param err [Error] the error
 * throwError throws an error and exits
 * @return null
 */
function throwError(err) {
  console.error(err);
  process.exit(
    1
  );
}

/**
 * @author Jordon Bedwell
 * @param file [String] the file
 * isValidPlugin checks if a plugin is valid
 * @note it checks that it matches '.js'
 * @return [Bool] true, false
 */
function isValidPlugin(file) {
  const stat = fs.lstatSync(file);
  if (path.extname(file) !== ".js") return false;
  if (stat.isDirectory()) return false;
  return true;
}

/**
 * pluginDir returns the plugin dir
 * @return [String]
 */
function pluginDir(api) {
  return path.join(api._app.context,
    "src", "plugins"
  );
}

/**
 * @author Jordon Bedwell
 * @param api [Api] the api
 * @param callback [function] a callback
 * pluginList gets a list of plugins
 * @return [Array] the files
 */
function pluginsList(api, callback) {
  let pdir = pluginDir(api);
  let list = [];

  if (typeof callback === "undefined") {
    callback = function(file) {
      return file
    }
  }

  if (fs.existsSync(pdir)) {
    let files = fs.readdirSync(dir);

    files.forEach(file => {
      let e_file = path.join(dir, file);
      if (!isValidPlugin(e_file)) {
        throwError(`invalid plugin ${
          file
        }`);
      }

      list.push(callback(
        e_file
      ));
    });
  }

  return list;
}

/**
 * @author Jordon Bedwell
 * @param api [Api] the api
 * loadPlugins loads all of the plugins
 * @return null
 */
function loadPlugins(api) {
  pluginsList(api, (plugin, func = require(plugin)) => {
    func(api);
  });
}

/**
 * @author Jordon Bedwell
 * @param api [Api] the api
 * loadMeta loads the config into meta
 * @return null
 */
function loadMeta(api) {
  api.loadSource(store => {
    Object.keys(config).forEach(k => {
      if (!config.skipOnMeta.includes(k)) {
        store.addMetaData(k,
          config[k]
        );
      }
    });
  });
}

/**
 * Learn more:
 * https://gridsome.org/docs/server-api
 */
module.exports = function(api) {
  [loadPlugins, loadMeta].forEach(func => {
    func(api);
  });
}
