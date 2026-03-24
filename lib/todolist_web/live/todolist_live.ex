defmodule TodolistWeb.TodoLive do
  use TodolistWeb, :live_view

  alias Todolist.Todos

  def mount(_params, _session, socket) do
    todos = Todos.list_todos()

    {:ok,
     socket
     |> assign(:page_title, "Todos")
     |> assign(:todos, todos)}
  end

  def render(assigns) do
    ~H"""
    <Layouts.app flash={@flash}>
      <div class="mx-auto max-w-3xl px-6 py-10">
        <div class="mb-8">
          <h1 class="text-3xl font-bold tracking-tight text-zinc-900">Todo List</h1>
          <p class="mt-2 text-sm text-zinc-600">해야 할 일을 한눈에 관리해보세요.</p>
        </div>

        <div class="rounded-2xl border border-zinc-200 bg-white p-6 shadow-sm">
          <div
            :if={@todos == []}
            class="rounded-xl border border-dashed border-zinc-300 px-6 py-10 text-center text-zinc-500"
          >
            아직 등록된 할 일이 없습니다.
          </div>

          <ul :if={@todos != []} id="todo-list" class="space-y-3">
            <li
              :for={todo <- @todos}
              id={"todo-#{todo.id}"}
              class="flex items-center justify-between rounded-xl border border-zinc-200 px-4 py-3 transition hover:border-zinc-300 hover:shadow-sm"
            >
              <div>
                <p class="font-medium text-zinc-900">{todo.title}</p>
                <p class="text-xs text-zinc-500">
                  {if todo.done, do: "완료됨", else: "진행 중"}
                </p>
              </div>

              <span class={[
                "inline-flex items-center rounded-full px-3 py-1 text-xs font-semibold",
                if(todo.done,
                  do: "bg-emerald-100 text-emerald-700",
                  else: "bg-amber-100 text-amber-700"
                )
              ]}>
                {if todo.done, do: "Done", else: "Todo"}
              </span>
            </li>
          </ul>
        </div>
      </div>
    </Layouts.app>
    """
  end
end
