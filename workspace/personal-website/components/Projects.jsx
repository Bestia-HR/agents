const projects = [
  {
    title: 'AI Chat Platform',
    description: 'Real-time chat application with OpenAI integration, vector search, and multi-agent workflows.',
    tags: ['React', 'AI'],
  },
  {
    title: 'Analytics Dashboard',
    description: 'Data visualization platform with real-time updates, custom charts, and automated reporting.',
    tags: ['Next.js', 'PostgreSQL'],
  },
  {
    title: 'ML Pipeline API',
    description: 'Machine learning model serving infrastructure with FastAPI, Docker, and Kubernetes deployment.',
    tags: ['Python', 'FastAPI'],
  },
]

export default function Projects() {
  return (
    <section className="projects" id="projects">
      <div className="section-header">
        <h2>Featured Projects</h2>
      </div>
      <div className="projects-grid">
        {projects.map(project => (
          <div key={project.title} className="project-card">
            <div className="project-tags">
              {project.tags.map(tag => (
                <span key={tag} className="project-tag">{tag}</span>
              ))}
            </div>
            <h3>{project.title}</h3>
            <p>{project.description}</p>
          </div>
        ))}
      </div>
    </section>
  )
}
