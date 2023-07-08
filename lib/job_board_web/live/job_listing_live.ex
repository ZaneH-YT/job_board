defmodule JobBoardWeb.JobListingLive do
  use JobBoardWeb, :live_view
  alias JobBoard.{Jobs, UserSaves}
  use SearchComponent

  def mount(params, _session, socket) do
    listing_id = params["id"]
    listing = Jobs.get_by_id!(listing_id)

    current_user = socket.assigns.current_user

    current_user_id =
      if current_user do
        current_user.id
      end

    listing =
      if current_user_id do
        %{listing | is_saved: UserSaves.is_saved?(listing_id, current_user_id)}
      else
        listing
      end

    {:ok,
     socket
     |> assign(:listing, listing)
     |> assign(:search_listings, [])
     |> assign(:search_term, "")
     |> assign(:current_user_id, current_user_id)}
  end

  def handle_event("toggle_save", _params, socket) do
    listing = socket.assigns.listing
    current_user = socket.assigns.current_user

    is_saved =
      if current_user do
        UserSaves.is_saved?(listing.id, current_user.id)
      end

    if current_user do
      if is_saved do
        UserSaves.remove_saved_listing_from_user!(listing.id, current_user.id)
      else
        UserSaves.add_saved_listing_to_user!(listing.id, current_user.id)
      end
    end

    listing = %{listing | is_saved: not is_saved}

    {:noreply,
     socket
     |> assign(:listing, listing)}
  end

  def handle_event("delete_listing", _params, socket) do
    listing = socket.assigns.listing
    current_user_id = socket.assigns.current_user_id

    if listing.user_id == current_user_id do
      Jobs.delete_listing!(listing.id)

      {:noreply,
       socket
       |> put_flash(:info, "Deleted listing")
       |> redirect(to: ~p"/")}
    else
      {:noreply, socket}
    end
  end

  def render(assigns) do
    ~H"""
    <.live_component module={SearchComponent} id="search" results={@search_listings} value={@search_term} />
    <article class="prose">
      <h2><%= @listing.title %></h2>
      <h3>
        <a target="_blank" href={"#{@listing.company_web_url}"}><%= @listing.company_name %></a>
      </h3>
      <button class="btn btn-primary" phx-click="toggle_save">
        <%= if @listing.is_saved do %>
          <.icon name="hero-heart-solid" />
        <% else %>
          <.icon name="hero-heart" />
        <% end %>
      </button>
      <%= if @listing.user_id == @current_user_id do %>
        <button class="btn btn-error" phx-click="delete_listing">
          <.icon name="hero-trash" />
        </button>
      <% end %>
      <p class="whitespace-pre"><%= @listing.description_md %></p>
    </article>
    """
  end
end
