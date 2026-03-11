export default function Footer() {
  const currentYear = new Date().getFullYear()
  
  return (
    <footer id="contact">
      <p>Let's build something together. Get in touch at hello@alexchen.dev</p>
      <p>© {currentYear} Alex Chen. All rights reserved.</p>
    </footer>
  )
}
