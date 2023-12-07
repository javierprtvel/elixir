defmodule DancingDots.Animation do
  @type dot :: DancingDots.Dot.t()
  @type opts :: keyword
  @type error :: any
  @type frame_number :: pos_integer

  @callback init(opts()) :: {:ok, opts()} | {:error, error()}
  @callback handle_frame(dot(), frame_number(), opts()) :: dot()

  defmacro __using__(_opts) do
    quote do
      @behaviour DancingDots.Animation
      def init(opts), do: {:ok, opts}
      defoverridable init: 1
    end
  end
end

defmodule DancingDots.Flicker do
  use DancingDots.Animation
  alias DancingDots.Animation

  @impl Animation
  def handle_frame(
        %DancingDots.Dot{x: x, y: y, radius: radius, opacity: opacity} = dot,
        frame_number,
        _opts
      ) do
    if rem(frame_number, 4) == 0,
      do: %DancingDots.Dot{x: x, y: y, radius: radius, opacity: opacity / 2},
      else: dot
  end
end

defmodule DancingDots.Zoom do
  alias DancingDots.Animation
  alias DancingDots.Dot

  @behaviour Animation

  @impl Animation
  def init([]) do
    {
      :error,
      "The :velocity option is required, and its value must be a number. Got: #{inspect(nil)}"
    }
  end

  @impl Animation
  def init(opts) do
    {:velocity, velocity} = Enum.find(opts, fn {oname, _ovalue} -> oname === :velocity end)

    if not is_number(velocity) do
      {
        :error,
        "The :velocity option is required, and its value must be a number. Got: #{inspect(velocity)}"
      }
    else
      {:ok, opts}
    end
  end

  @impl Animation
  def handle_frame(
        %DancingDots.Dot{x: x, y: y, radius: radius, opacity: opacity} = _dot,
        frame_number,
        opts
      ) do
    {:velocity, velocity} = Enum.find(opts, fn {oname, _ovalue} -> oname === :velocity end)

    %Dot{x: x, y: y, radius: radius + (frame_number - 1) * velocity, opacity: opacity}
  end
end
