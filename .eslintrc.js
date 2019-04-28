module.exports = {
  extends: "standard",
  env: { browser: true, es6: true },
  globals: { SharedArrayBuffer: "readonly", Atomics: "readonly" },
  parserOptions: { sourceType: "module", ecmaVersion: 2018 },
  plugins: ["vue"],
  rules: {
    "space-before-function-paren": [2, {
        "anonymous": "always",
        "asyncArrow": "always",
        "named": "never",
    }],
    "quotes": [2,
      "double"
    ]
  }
}
