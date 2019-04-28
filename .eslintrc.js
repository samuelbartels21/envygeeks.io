module.exports = {
  extends: "standard",
  env: { browser: true, es6: true },
  globals: { SharedArrayBuffer: "readonly", Atomics: "readonly" },
  parserOptions: { sourceType: "module", ecmaVersion: 2018 }
  plugins: ["vue"]
  rules: {}
}
