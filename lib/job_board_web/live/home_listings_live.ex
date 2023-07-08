defmodule JobBoardWeb.HomeListingsLive do
  alias JobBoard.UserSaves
  alias JobBoard.Jobs
  use JobBoardWeb, :live_view
  use SearchComponent

  def mount(_params, _session, socket) do
    listings = Jobs.get_newest_listings()
    current_user = socket.assigns.current_user

    listings =
      if current_user do
        Enum.map(listings, fn l ->
          %{l | is_saved: UserSaves.is_saved?(l.id, current_user.id)}
        end)
      else
        listings
      end

    {:ok,
     socket
     |> assign(:listings, listings)
     |> assign(:search_listings, [])
     |> assign(:search_term, "")}
  end

  def handle_event("toggle_save", %{"id" => listing_id, "saved" => is_saved}, socket) do
    current_user = socket.assigns.current_user
    {listing_id, _} = Integer.parse(listing_id)
    is_saved = is_saved == "true"

    if current_user do
      if is_saved do
        UserSaves.remove_saved_listing_from_user!(listing_id, current_user.id)
      else
        UserSaves.add_saved_listing_to_user!(listing_id, current_user.id)
      end
    end

    listings = socket.assigns.listings

    updated_listings =
      Enum.map(listings, fn l ->
        if l.id == listing_id do
          %{l | is_saved: not is_saved}
        else
          l
        end
      end)

    {:noreply, socket |> assign(:listings, updated_listings)}
  end

  def render(assigns) do
    ~H"""
    <.live_component
      module={SearchComponent}
      id="search"
      results={@search_listings}
      value={@search_term}
    />
    <article class="prose mx-auto px-4">
      <div class="pt-8">
        <h1 class="text-center">Elixir Job Board</h1>
      </div>

      <div>
        <h2>Listings</h2>
        <div class="flex flex-col gap-6">
          <%= for listing <- assigns.listings do %>
            <.live_component module={ListingComponent} id={listing.id} listing={listing} />
          <% end %>
        </div>
      </div>
    </article>
    """
  end
end
