module Timer exposing (main)

import Browser
import Duration
import Element exposing (Element)
import Element.Font
import Element.Input
import Millis exposing (Millis(..), millis)
import Time


type alias Flags =
    ()


type alias Model =
    { now : Time.Posix }


type Msg
    = NoOp
    | GotCurrentTime Time.Posix


init : () -> ( Model, Cmd msg )
init () =
    ( { now = Time.millisToPosix 0 }, Cmd.none )


view : Model -> Browser.Document Msg
view model =
    { title = "Timers"
    , body = [ mainView model |> Element.layout [ Element.padding 30 ] ]
    }


mainView : Model -> Element Msg
mainView model =
    Element.column
        [ Element.spacing 30, Element.centerX, Element.width Element.fill ]
        [ Element.text "Time until New Year's"
        , timerView model.now
        ]


timerView : Time.Posix -> Element msg
timerView now =
    now
        |> millisUntilNewYears
        |> Duration.inDays
        |> String.fromFloat
        |> Element.text


millisUntilNewYears : Time.Posix -> Duration.Duration
millisUntilNewYears now =
    Duration.from
        now
        newYears2020


newYears2020 : Time.Posix
newYears2020 =
    Time.millisToPosix 1577865600000


main : Program Flags Model Msg
main =
    Browser.document
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        }


subscriptions model =
    Time.every 500 GotCurrentTime


update : Msg -> Model -> ( Model, Cmd msg )
update msg model =
    case msg of
        NoOp ->
            ( model, Cmd.none )

        GotCurrentTime currentTime ->
            ( { model | now = currentTime }, Cmd.none )