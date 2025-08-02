import { authClient } from '@/lib/auth'
import { createFileRoute, redirect } from '@tanstack/react-router'

export const Route = createFileRoute('/')({
  component: RouteComponent,
  loader: async ({context}) =>{
    const {data} = await authClient.getSession()

    if(data === null)
    throw redirect({
        to: '/login',
      })
  }
})

function RouteComponent() {
  const { data: session, isPending } = authClient.useSession();

  return <div>Hello {session?.user?.name}!</div>
}
