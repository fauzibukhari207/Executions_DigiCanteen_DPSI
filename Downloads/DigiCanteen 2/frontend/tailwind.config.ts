import type { Config } from 'tailwindcss';

// Token warna, tipografi, shadow, dan radius diambil langsung dari
// Design_System__DS_.md v3.0 (Neo-Brutalist, awalnya berjudul prototipe "KantinKita" -> nama produk final: DigiCanteen).
// Jangan ubah nilai di sini tanpa mengubah dokumen SoT terlebih dahulu.

const config: Config = {
  content: [
    './app/**/*.{ts,tsx}',
    './components/**/*.{ts,tsx}',
    './lib/**/*.{ts,tsx}',
  ],
  theme: {
    extend: {
      colors: {
        background: '#f9f9f9',
        surface: '#f9f9f9',
        'surface-container-lowest': '#ffffff',
        'surface-container-low': '#f3f3f3',
        'surface-container': '#eeeeee',
        'surface-container-high': '#e8e8e8',
        'surface-container-highest': '#e2e2e2',
        'surface-variant': '#e2e2e2',
        'surface-dim': '#dadada',

        'on-background': '#1b1b1b',
        'on-surface': '#1b1b1b',
        'on-surface-variant': '#5b4138',
        'inverse-on-surface': '#f1f1f1',
        outline: '#1b1b1b',
        'outline-variant': '#1b1b1b',

        primary: '#ab3600',
        'primary-container': '#ff5f1f',
        'primary-fixed': '#ffdbcf',
        'on-primary': '#ffffff',
        'on-primary-container': '#561700',

        secondary: '#7a5900',
        'secondary-container': '#fcbc05',
        'secondary-fixed': '#ffdea2',
        'on-secondary': '#ffffff',
        'on-secondary-container': '#6b4e00',

        tertiary: '#bf0025',
        'tertiary-container': '#ff5b5e',
        'on-tertiary': '#ffffff',
        'on-tertiary-container': '#61000e',

        error: '#ba1a1a',
        'error-container': '#ffdad6',
        'on-error': '#ffffff',
        'on-error-container': '#93000a',
      },
      fontFamily: {
        sans: ['var(--font-archivo)', 'Archivo Narrow', 'sans-serif'],
        mono: ['var(--font-jetbrains)', 'JetBrains Mono', 'monospace'],
      },
      fontSize: {
        'display-xl': ['80px', { lineHeight: '80px', letterSpacing: '-0.04em', fontWeight: '900' }],
        'headline-lg': ['48px', { lineHeight: '52px', letterSpacing: '-0.02em', fontWeight: '800' }],
        'headline-lg-mobile': ['32px', { lineHeight: '36px', letterSpacing: '-0.02em', fontWeight: '800' }],
        'headline-md': ['24px', { lineHeight: '28px', fontWeight: '800' }],
        'body-lg': ['18px', { lineHeight: '28px', fontWeight: '500' }],
        'body-md': ['16px', { lineHeight: '24px', fontWeight: '500' }],
        'label-bold': ['14px', { lineHeight: '16px', letterSpacing: '0.05em', fontWeight: '700' }],
        'label-sm': ['12px', { lineHeight: '14px', fontWeight: '500' }],
      },
      // Radius 0 di semua ukuran kecuali "full" — identitas utama Neo-Brutalist.
      borderRadius: {
        none: '0px',
        DEFAULT: '0px',
        sm: '0px',
        md: '0px',
        lg: '0px',
        xl: '0px',
        full: '9999px',
      },
      borderWidth: {
        DEFAULT: '2px',
        3: '3px',
        4: '4px',
        5: '5px',
      },
      boxShadow: {
        none: 'none',
        sm: '4px 4px 0px 0px #1b1b1b',
        md: '6px 6px 0px 0px #1b1b1b',
        lg: '8px 8px 0px 0px #1b1b1b',
        xl: '12px 12px 0px 0px #1b1b1b',
        DEFAULT: '4px 4px 0px 0px #1b1b1b',
      },
      spacing: {
        unit: '4px',
        gutter: '24px',
        margin: '32px',
      },
      maxWidth: {
        'container-max': '1280px',
      },
      transitionDuration: {
        press: '100ms',
        lift: '200ms',
      },
    },
  },
  plugins: [],
};

export default config;
