module.exports = {
  globals: {},
  transform: {
    '\\.js$': 'babel-jest',
    '\\.vue$': '@vue/vue3-jest'
  },
  moduleFileExtensions: ['vue', 'js', 'json'],
  testPathIgnorePatterns: ['<rootDir>/vendor/'],
}
