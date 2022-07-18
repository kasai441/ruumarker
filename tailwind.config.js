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
        '108': '27rem',
        '144': '36rem',
        '168': '42rem'
      },
      width: {
        '30vw': '30vw',
        '78vw': '78vw',
        '84vw': '84vw',
      },
      minWidth: {
        '68': '17rem'
      },
      maxWidth: {
        '48': '12rem',
        '144': '36rem'
      },
      height: {
        '30vw2/3': 'calc(30vw * 2/3)',
        '78vw2/3': 'calc(78vw * 2/3)'
      },
      inset: {
        '76vh': 'calc(76vh)',
        '80vw': 'calc(80vw)',
        'max': 'calc(50vw + 21rem)'
      },
      outlineWidth: {
        32: '32px',
        112: '112px',
        240: '240px'
      },
      strokeWidth: {
        '3': '3px',
      },
      animation: {
        fadeout: 'fadeout 2.5s ease 1',
        halfvanish: 'halfvanish 0.5s ease 1'
      },
      keyframes: {
        fadeout: {
          '0%': { 'background': 'rgba(223, 223, 223, 1)' },
          '20%': { 'background': 'rgba(223, 223, 223, 1)' },
          '100%': { 'background': 'rgba(223, 223, 223, 0)' }
        },
        halfvanish: {
          '0%': { 'opacity': 0.7 },
          '100%': { 'opacity': 0.4}
        }
      },
      screens: {
        'print': {'raw': 'print'}
      }
    }
  }
}
