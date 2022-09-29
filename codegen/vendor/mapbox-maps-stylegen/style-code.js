// Global functions //

const fs = require('fs');
const path = require('path');
const _ = require('lodash');

global.iff = function (condition, val) {
  return condition() ? val : "";
};

global.camelize = function (str) {
  return str.replace(/(?:^|-)(.)/g, function (_, x) {
    return x.toUpperCase();
  });
};

global.camelizeWithUndercoreRemoved = function (str) {
  return str.replace(/(^|_)./g, s => s.slice(-1).toUpperCase())
}

// https://github.com/mapbox/mapbox-maps-ios-internal/issues/835
global.swiftSanitize = function (str) {
  return str.replace("json", "JSON")
}

global.camelizeWithLeadingLowercaseUndercoreRemoved = function (str) {
  str = camelizeWithUndercoreRemoved(str)
  return str.charAt(0).toLowerCase() + str.slice(1);
}

global.camelizeWithLeadingLowercase = function (str) {
  return str.replace(/-(.)/g, function (_, x) {
    return x.toUpperCase();
  });
};

global.snakeCaseUpper = function snakeCaseUpper(str) {
  return str.replace(/-/g, "_").toUpperCase();
};

global.snakeCaseUpperNoDash = function snakeCaseUpperNoDash(str) {
  return str.replace(/[A-Z]/g, m => "_" + m).toUpperCase();
};

global.unhyphenate = function (str) {
  return str.replace(/-/g, " ");
};

global.replaceHyphenateWithUnderScore = function (str) {
  return str.replace(/-/g, "_");
};

global.removeUnderScore = function (str) {
  return str.replace(/_/g, "");
};

// Write out a list of files that this script is modifying so that we can check
var files = [];
process.on('exit', function () {
  const list = path.join(path.dirname(process.argv[1]), path.basename(process.argv[1], '.js') + '.list');
  fs.writeFileSync(list, files.join('\n'));
});

global.writeIfModified = function (filename, newContent) {
  files.push(filename);
  try {
    const oldContent = fs.readFileSync(filename, 'utf8');
    if (oldContent == newContent) {
      console.warn(`* Skipping file '${filename}' because it is up-to-date`);
      return;
    }
  } catch (err) {
  }
  if (['0', 'false'].indexOf(process.env.DRY_RUN || '0') !== -1) {
    fs.writeFileSync(filename, newContent);
  }
  console.warn(`* Updating outdated file '${filename}'`);
};

global.blockDoc = function(property, indentation) {
  let lines = property.doc.split('\n').map(s => s.trimEnd() ? `/// ${s.trimEnd()}` : '///');
  return lines.map(ss => ss ? ' '.repeat(indentation) + ss : ss).join('\n');
}

global.blockDocString = function(doc, indentation) {
  let lines = doc.split('\n').map(s => s.trimEnd() ? `/// ${s.trimEnd()}` : '///');
  return lines.map(ss => ss ? ' '.repeat(indentation) + ss : ss).join('\n');
}

global.blockDocAndroid = function(property, indentation, appendedBlock, wordsPerLine) {
  var origDoc = property.doc.replace(/\*/gi, '-')
  if (appendedBlock) {
    origDoc = origDoc + appendedBlock
  }
  if (!wordsPerLine) {
    wordsPerLine = 16
  }
  let doc = wrapToLines(origDoc, wordsPerLine)
  let map = ['/**', ...doc.map(s => s.trim() ? ` * ${s.trim()}` : ' *'), ' */'];
  return map.map(ss => ss ? ' '.repeat(indentation) + ss : ss).join('\n');
}

function wrapToLines(str, wordsPerLine) {
  return flatten(str.split('\n').map(line => chunkString(line, wordsPerLine)))
}

function chunkString(str, wordsPerLine) {
  var words = str.split(' ')
  return _.chunk(words, wordsPerLine).map(word => word.join(' '))
}

function flatten(arr) {
  return arr.reduce(function (flat, toFlatten) {
    return flat.concat(Array.isArray(toFlatten) ? flatten(toFlatten) : toFlatten);
  }, []);
}

global.indent = (n) =>
    (s) => s.split('\n').map(ss => ss ? ' '.repeat(n) + ss : ss).join('\n');
