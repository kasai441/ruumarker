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
        '72': '18rem',
        '104': '26rem',
        '112': '28rem',
        '144': '36rem',
        '156': '39rem',
        '168': '42rem'
      },
      width: {
        '24vw': '24vw',
        '82vw': '82vw',
        '92vw': '92vw',
      },
      minWidth: {
        '72': '18rem'
      },
      maxWidth: {
        '72': '18rem',
        '144': '36rem'
      },
      height: {
        '24vw2/3': 'calc(24vw * 2/3)',
        '82vw2/3': 'calc(82vw * 2/3)',
        '92vw2/3': 'calc(92vw * 2/3)'
      },
      inset: {
        '78vh': 'calc(78vh)',
        '82vw': 'calc(82vw)'
      },
      outlineWidth: {
        32: '32px',
        112: '112px',
        240: '240px'
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
      }
    }
  }
}
