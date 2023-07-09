defmodule JobBoardWeb.NewListingLive do
  alias JobBoard.Categories
  alias JobBoard.Jobs
  alias JobBoard.Jobs.Listing
  use JobBoardWeb, :live_view

  def mount(_params, _session, socket) do
    form = Listing.changeset(%Listing{})
    categories = Categories.get_all()

    {:ok,
     socket
     |> assign(:form, form |> to_form())
     |> assign(:categories, categories)}
  end

  def handle_event("validate", params, socket) do
    form =
      Listing.changeset(%Listing{}, params)
      |> Map.put(:action, :validate)
      |> to_form()

    {:noreply, socket |> assign(:form, form)}
  end

  def handle_event("save", params, socket) do
    form =
      Listing.changeset(
        %Listing{},
        params
        |> Map.put("user_id", socket.assigns.current_user.id)
      )

    case Jobs.create_listing(form) do
      {:ok, _} ->
        {:noreply,
         socket
         |> put_flash(:info, "Listing created")
         |> redirect(to: ~p"/listings/new")}

      {:error, changeset} ->
        {:noreply, socket |> assign(:form, changeset |> to_form())}
    end
  end

  def render(assigns) do
    ~H"""
    <article class="prose">
      <h2>Create a Listing</h2>
      <.form for={@form} class="w-[70%] space-y-5" phx-submit="save" phx-change="validate">
        <div>
          <.label for="title">Position Title</.label>
          <.input
            type="text"
            field={@form[:title]}
            id="title"
            name="title"
            placeholder="e.g. Engineer"
          />
        </div>

        <div class="divider" />

        <div>
          <.label for="company_name">Company Name</.label>
          <.input
            type="text"
            field={@form[:company_name]}
            id="company_name"
            name="company_name"
            placeholder="e.g. Lorem Ipsum LLC."
          />
        </div>

        <div>
          <.label for="company_web_url">Company Web URL</.label>
          <.input
            type="text"
            field={@form[:company_web_url]}
            id="company_web_url"
            name="company_web_url"
            placeholder="e.g. https://lorem.com/about-us"
          />
        </div>

        <div>
          <.label for="description">Description</.label>
          <.input
            type="textarea"
            field={@form[:description]}
            id="description"
            name="description"
            placeholder="Give details about the position..."
          />
        </div>

        <div>
          <.label for="category_id">Job Category</.label>
          <.input
            type="select"
            field={@form[:category_id]}
            id="category_id"
            name="category_id"
            options={Enum.map(@categories, &{&1.name, &1.id})}
            prompt="Select a category..."
          />
        </div>

        <button type="submit" class="btn btn-primary float-right mt-8">Create</button>
      </.form>
    </article>
    """
  end
end
