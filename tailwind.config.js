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
        112: '112px',
        240: '240px'
      },
      zIndex: {
        '60': '60'
      },
      minWidth: {
        '72': '18rem',
      },
      animation: {
        fadeout: 'fadeout 1s ease 1',
      },
      keyframes: {
        fadeout: {
          '0%': { 'background': 'rgba(223, 223, 223, 1)' },
          '100%': { 'background': 'rgba(223, 223, 223, 0)' }
        }
      }
    }
  }
}
