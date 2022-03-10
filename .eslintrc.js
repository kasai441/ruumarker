module.exports = {
    root: true,
    parser: 'vue-eslint-parser',
    parserOptions: {
        "ecmaVersion": 2021,
        parser: '@babel/eslint-parser',
        sourceType: 'module'
    },
    extends: ['standard'],
    plugins: [
        'vue'
    ],
    rules: {
        'vue/html-indent': ['error', 2]
    }
}
