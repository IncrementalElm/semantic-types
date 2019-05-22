module Social exposing (main)

import Browser
import Duration
import Element exposing (Element)
import Element.Events
import Element.Font
import Element.Input
import Millis exposing (Millis(..), millis)
import Time


type alias Flags =
    ()


type alias Model =
    { ssnInput : String
    , ssnFocus : FocusState
    }


type Msg
    = NoOp
    | ChangedSsnInput String
    | SsnFocusChanged FocusState


init : () -> ( Model, Cmd msg )
init () =
    ( { ssnInput = ""
      , ssnFocus = OutOfFocus
      }
    , Cmd.none
    )


view : Model -> Browser.Document Msg
view model =
    { title = "Semantic Types Demo"
    , body = [ mainView model |> Element.layout [ Element.padding 30 ] ]
    }


type FocusState
    = InFocus
    | OutOfFocus


mainView : Model -> Element Msg
mainView model =
    Element.column
        [ Element.spacing 30, Element.centerX, Element.width Element.fill ]
        [ Element.Input.text
            [ Element.Events.onFocus (SsnFocusChanged InFocus)
            , Element.Events.onLoseFocus (SsnFocusChanged OutOfFocus)
            ]
            { onChange = ChangedSsnInput
            , text =
                case model.ssnFocus of
                    InFocus ->
                        model.ssnInput

                    OutOfFocus ->
                        model.ssnInput |> maskSsn
            , placeholder = Nothing
            , label = Element.Input.labelAbove [] (Element.text "SSN")
            }
        ]


maskSsn : String -> String
maskSsn ssn =
    ssn
        |> String.replace "0" "X"


main : Program Flags Model Msg
main =
    Browser.document
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        }


subscriptions model =
    Sub.none


update : Msg -> Model -> ( Model, Cmd msg )
update msg model =
    case msg of
        NoOp ->
            ( model, Cmd.none )

        ChangedSsnInput changedSsn ->
            ( { model | ssnInput = changedSsn }, Cmd.none )

        SsnFocusChanged focusState ->
            ( { model | ssnFocus = focusState }, Cmd.none )
