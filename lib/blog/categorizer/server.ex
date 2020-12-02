defmodule Blog.Categorizer.Server do
  use GenServer

  alias Blog.Categorizer.Services

  @doc """
  Starts the index server.
  """
  def start_link(_args) do
    GenServer.start_link(__MODULE__, :ok, name: __MODULE__)
  end

  @doc """
  Updates the index when category added, removed or changed
  """
  def update_index(operation, opts) do
    GenServer.cast(__MODULE__, {:update_index, operation, opts})
  end

  @doc """
  Adds categories to post keywords matching
  """
  def categorize_post(opts) do
    GenServer.cast(__MODULE__, {:categorize_post, opts})
  end

  @doc """
  Get the current index
  """
  def index do
    GenServer.call(__MODULE__, :get_index)
  end

  @doc """
  Clear index
  """
  def clear_index do
    GenServer.cast(__MODULE__, {:clear_index})
  end

  ## Defining GenServer Callbacks

  @impl true
  def init(_args) do
    index = Services.BuildIndex.call
    
    {:ok, index}
  end

  @impl true
  def handle_cast({:update_index, operation, opts}, index) do
    updated_index = Services.UpdateIndex.call(operation, index, opts)

    {:noreply, updated_index}
  end

  @impl true
  def handle_cast({:categorize_post, opts}, index) do
    Services.PostsCategorizer.call(index, opts)

    {:noreply, index}
  end

  @impl true
  def handle_cast({:clear_index}, _index) do
    {:noreply, %{}}
  end

  @impl true
  def handle_call(:get_index, _from, index) do
    {:reply, index, index}
  end
end
