defmodule JobBoardWeb.MyListingsLive do
  alias JobBoard.Jobs
  alias JobBoard.UserSaves
  use JobBoardWeb, :live_view

  def mount(_params, _session, socket) do
    current_user_id = socket.assigns.current_user.id
    my_listings = Jobs.get_by_user_id(current_user_id)

    my_listings =
      Enum.map(my_listings, fn l ->
        %{l | is_saved: UserSaves.is_saved?(l.id, current_user_id)}
      end)

    {:ok, socket |> assign(:listings, my_listings)}
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
    <article class="prose">
      <h2>Listings</h2>
      <div class="flex flex-col gap-6">
        <%= for listing <- @listings do %>
          <.live_component module={ListingComponent} id={listing.id} listing={listing} />
        <% end %>
      </div>
    </article>
    """
  end
end
