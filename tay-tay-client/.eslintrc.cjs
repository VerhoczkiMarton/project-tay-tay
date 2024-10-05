module.exports = {
    env: {
        browser: true,
        es2021: true,
    },
    extends: [
        'google',
        'plugin:react/recommended',
        'plugin:jest/recommended',
    ],
    parserOptions: {
        ecmaVersion: 'latest',
        sourceType: 'module',
    },
    plugins: ['react'],
    rules: {
        'require-jsdoc' : 0
    },
    settings: {
        react: {
            version: 'detect',
        },
    },
    overrides: [
        {
            files: ["**/*.js", "**/*.jsx", "**/*.ts", "**/*.tsx"],
        },
    ],
};
