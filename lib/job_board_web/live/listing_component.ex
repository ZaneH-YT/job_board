defmodule ListingComponent do
  use Phoenix.LiveComponent
  import JobBoardWeb.CoreComponents

  def render(assigns) do
    ~H"""
    <div class="shadow-md card bg-neutral text-neutral-content not-prose">
      <div class="card-body">
        <div class="flex flex-row justify-between">
          <div>
            <h2 class="card-title">
              <%= @listing.title %>
              <div class="ml-1 badge">
                <%= @listing.category.name %>
              </div>
            </h2>
            <p>
              <%= @listing.company_name %> • <%= abs(
                round(
                  DateTime.diff(
                    DateTime.from_naive!(
                      @listing.inserted_at,
                      "Etc/UTC"
                    ),
                    DateTime.utc_now()
                  ) / 86400
                )
              ) %> days ago
            </p>
          </div>

          <div class="join join-horizontal my-auto">
            <button
              phx-click="toggle_save"
              phx-value-id={"#{@listing.id}"}
              phx-value-saved={"#{@listing.is_saved}"}
              class="join-item btn btn-primary"
            >
              <%= if @listing.is_saved do %>
                <.icon name="hero-heart-solid" />
              <% else %>
                <.icon name="hero-heart" />
              <% end %>
            </button>
            <.link navigate={"/view/#{@listing.id}"}>
              <button class="join-item btn btn-primary">View</button>
            </.link>
          </div>
        </div>
      </div>
    </div>
    """
  end
end
