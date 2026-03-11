const navItems = [
  { label: 'About', href: '#about' },
  { label: 'Projects', href: '#projects' },
  { label: 'Contact', href: '#contact' },
]

// React 19: ref can be passed as a prop directly (no forwardRef needed)
export default function Navbar({ ref }) {
  return (
    <nav ref={ref}>
      <div className="logo">AC</div>
      <div className="nav-links">
        {navItems.map(item => (
          <a key={item.href} href={item.href}>
            {item.label}
          </a>
        ))}
      </div>
    </nav>
  )
}
