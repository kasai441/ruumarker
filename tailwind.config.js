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
        '88': '22rem',
        '112': '28rem',
        '132': '33rem',
        '144': '36rem',
        '156': '39rem',
        '168': '42rem'
      },
      width: {
        '30vw': '30vw',
        '78vw': '78vw',
        '84vw': '84vw',
        '91vw': '91vw'
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
        '78vw2/3': 'calc(78vw * 2/3)',
        '91vw2/3': 'calc(91vw * 2/3)'
      },
      inset: {
        '76vh': 'calc(76vh)',
        '80vw': 'calc(80vw)',
        'max': 'calc(50vw + 21rem)',
        'mid': 'calc(50vw - 1rem)',
        'kana': '17px'
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
        select: 'select 2.5s ease 1',
        fadeout: 'fadeout 0.5s ease 1',
        slidein: 'slidein 0.5s ease 1',
        slideout: 'slideout 0.5s ease 1'
      },
      keyframes: {
        select: {
          '0%': { 'background': 'rgba(239, 239, 239, 1)' },
          '20%': { 'background': 'rgba(239, 239, 239, 1)' },
          '100%': { 'background': 'rgba(239, 239, 239, 0)' }
        },
        fadeout: {
          '0%': { 'opacity': 0.7 },
          '100%': { 'opacity': 0.4}
        },
        slidein: {
          '0%': { 'top': 'calc(100vh + 10rem)' },
          '100%': { 'top': 'calc(76vh)' }
        },
        slideout: {
          '0%': { 'top': 'calc(76vh)' },
          '100%': { 'top': 'calc(100vh + 10rem)', }
        }
      },
      screens: {
        'print': {'raw': 'print'}
      }
    }
  }
}
