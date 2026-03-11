const features = [
  {
    title: 'Frontend Development',
    description: 'React, Next.js, TypeScript, Tailwind CSS. Building responsive, performant user interfaces.',
  },
  {
    title: 'Backend Systems',
    description: 'Node.js, Python, PostgreSQL, Redis. Scalable APIs and microservices architecture.',
  },
  {
    title: 'AI Integration',
    description: 'OpenAI, LangChain, vector databases. Implementing LLM-powered features and agents.',
  },
]

export default function Features() {
  return (
    <section className="features" id="about">
      <div className="section-header">
        <h2>What I Do</h2>
      </div>
      <div className="features-grid">
        {features.map(feature => (
          <div key={feature.title} className="feature-card">
            <h3>{feature.title}</h3>
            <p>{feature.description}</p>
          </div>
        ))}
      </div>
    </section>
  )
}
