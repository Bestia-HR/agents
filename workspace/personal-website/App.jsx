import Navbar from './components/Navbar'
import Hero from './components/Hero'
import Features from './components/Features'
import Projects from './components/Projects'
import Footer from './components/Footer'
import './App.css'

// React 19: Document metadata directly in component
export default function App() {
  return (
    <>
      <title>Alex Chen — Full Stack Developer</title>
      <meta name="description" content="Building intelligent applications with modern technologies" />
      
      <Navbar />
      <main>
        <Hero />
        <Features />
        <Projects />
      </main>
      <Footer />
    </>
  )
}
