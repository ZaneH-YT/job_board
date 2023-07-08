defmodule JobBoardWeb.HomeListingsLive do
  use JobBoardWeb, :live_view
  alias JobBoard.Jobs

  def mount(_params, _session, socket) do
    listings = Jobs.get_newest_listings()

    {:ok,
     socket
     |> assign(:listings, listings)}
  end

  def render(assigns) do
    ~H"""
    <article class="prose mx-auto px-4">
      <div class="pt-8">
        <h1 class="text-center">Elixir Job Board</h1>
      </div>

      <div>
        <h2>Listings</h2>
        <div class="flex flex-col gap-6">
          <%= for listing <- assigns.listings do %>
            <h2><%= listing.title %></h2>
          <% end %>
        </div>
      </div>
    </article>
    """
  end
end
