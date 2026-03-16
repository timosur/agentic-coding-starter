import { useEffect, useState } from 'react'
import { apiFetch } from '@/api/client'

interface HealthStatus {
  status: string
}

export default function Home() {
  const [health, setHealth] = useState<HealthStatus | null>(null)
  const [error, setError] = useState<string | null>(null)

  useEffect(() => {
    apiFetch<HealthStatus>('/api/health')
      .then(setHealth)
      .catch((err) => setError(err.message))
  }, [])

  return (
    <div className="min-h-screen flex flex-col items-center justify-center p-8">
      <h1 className="text-4xl font-bold mb-4">Starter App</h1>
      <p className="text-gray-600 dark:text-gray-400 mb-8">
        A Python + React starter template with AI coding support.
      </p>

      <div className="bg-gray-100 dark:bg-gray-800 rounded-lg p-4">
        <h2 className="text-lg font-semibold mb-2">API Health Check</h2>
        {error && <p className="text-red-500">Error: {error}</p>}
        {health && (
          <p className="text-green-500">
            Status: {health.status}
          </p>
        )}
        {!health && !error && (
          <p className="text-gray-500">Loading...</p>
        )}
      </div>
    </div>
  )
}
