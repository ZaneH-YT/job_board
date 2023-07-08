defmodule SearchComponent do
  use Phoenix.LiveComponent
  alias JobBoard.Jobs

  defmacro __using__(_opts) do
    quote do
      def handle_event("search", %{"search" => search}, socket) do
        listings = Jobs.search_listings(search)
        {:noreply, socket
        |> assign(:search_listings, listings)
        |> assign(:search_term, search)}
      end

      def handle_event("search_blur", _params, socket) do
        :timer.sleep(150)
        {:noreply, socket |> assign(:search_listings, [])}
      end
    end
  end

  def render(assigns) do
    ~H"""
    <div class="flex flex-col py-4 items-center">
      <form class="w-full">
        <input
          value={assigns.value}
          class="input input-bordered input-info w-full"
          type="text"
          placeholder="Search by title, company name, or tech..."
          phx-change="search"
          phx-debounce="300"
          name="search"
          autocomplete="off"
          phx-blur="search_blur"
        />
      </form>
      <%= if length(assigns.results) > 0 do %>
        <ul class="menu bg-base-200 rounded-box w-full">
          <li class="menu-title">Results</li>
          <%= for result <- assigns.results do %>
            <li>
              <.link navigate={"/view/#{result.id}"}>
                <%= result.title %> • <%= result.company_name %>
                <div class="badge badge-primary">
                  <%= result.category.name %>
                </div>
              </.link>
            </li>
          <% end %>
        </ul>
      <% end %>
    </div>
    """
  end
end
