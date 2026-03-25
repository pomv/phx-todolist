defmodule TodolistWeb.TodoLive do
  use TodolistWeb, :live_view

  alias Todolist.Todos
  alias Todolist.Todos.Todo

  def mount(_params, _session, socket) do
    {:ok,
     socket
     |> assign(:page_title, "Todos")
     |> assign(:todos, Todos.list_todos())
     |> assign(:form, to_form(Todos.change_todo(%Todo{})))}
  end

  def handle_event("save", %{"todo" => todo_params}, socket) do
    case Todos.create_todo(todo_params) do
      {:ok, _todo} ->
        {:noreply,
         socket
         |> assign(:todos, Todos.list_todos())
         |> assign(:form, to_form(Todos.change_todo(%Todo{})))}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, :form, to_form(changeset))}
    end
  end

  def handle_event("toggle", %{"id" => id}, socket) do
    todo = Enum.find(socket.assigns.todos, &(to_string(&1.id) == id))

    if todo do
      {:ok, _todo} = Todos.update_todo(todo, %{done: !todo.done})
      {:noreply, assign(socket, :todos, Todos.list_todos())}
    else
      {:noreply, socket}
    end
  end

  def handle_event("delete", %{"id" => id}, socket) do
    todo = Enum.find(socket.assigns.todos, &(to_string(&1.id) == id))

    if todo do
      {:ok, _todo} = Todos.delete_todo(todo)
      {:noreply, assign(socket, :todos, Todos.list_todos())}
    else
      {:noreply, socket}
    end
  end

  def render(assigns) do
    ~H"""
    <Layouts.app flash={@flash}>
      <div class="mx-auto max-w-xl p-6">
        <h1 class="text-xl font-semibold pb-2">투두 리스트</h1>

        <div class="border-b py-4">
          <.form for={@form} id="todo-form" phx-submit="save" class="space-y-2">
            <.input
              field={@form[:title]}
              type="text"
              placeholder="할 일을 입력하세요. 추가하면 꼭 해내세요."
            />

            <button type="submit" id="todo-submit" class="w-full rounded border px-3 py-2">
              추가
            </button>
          </.form>
        </div>

        <div class="pt-4">
          <p :if={@todos == []}>할 일이 없습니다.</p>

          <ul id="todo-list" class="list-disc pl-6 space-y-1">
            <li :for={todo <- @todos} id={"todo-#{todo.id}"}>
              <div class="flex items-center justify-between gap-2">
                <span class={[
                  todo.done && "line-through text-zinc-500"
                ]}>
                  {todo.title}
                </span>

                <div class="flex gap-1">
                  <button
                    type="button"
                    phx-click="toggle"
                    phx-value-id={todo.id}
                    class="rounded border px-2 py-1 text-xs"
                  >
                    {if todo.done, do: "되돌리기", else: "완료"}
                  </button>

                  <button
                    type="button"
                    phx-click="delete"
                    phx-value-id={todo.id}
                    class="rounded border px-2 py-1 text-xs"
                  >
                    삭제
                  </button>
                </div>
              </div>
            </li>
          </ul>
        </div>
      </div>
    </Layouts.app>
    """
  end
end
