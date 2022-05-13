module.exports = {
  content: [
    './app/views/**/*.html.slim',
    './app/helpers/**/*.rb',
    './app/assets/stylesheets/**/*.css',
    './app/javascript/**/*.js',
    './app/javascript/**/*.vue'
  ],
  plugins: [
    require('daisyui')
  ],
  theme: {
    extend: {
      spacing: {
        '56': '14rem',
        '72': '18rem',
        '84': '21rem',
        '108': '27rem'
      },
      outlineWidth: {
        32: '32px',
        60: '60px',
        112: '112px'
      },
      zIndex: {
        '60': '60'
      }
    }
  }
}
