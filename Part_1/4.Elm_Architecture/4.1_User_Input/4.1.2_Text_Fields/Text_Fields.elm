module TextFields exposing (..)

import Html exposing (Html, div, text, input, h1)
import Html.Attributes exposing (placeholder)
import Html.Events exposing (onInput)


main =
    Html.beginnerProgram { model = model, update = update, view = view }



-- MODEL


type alias Model =
    { content : String }


model : Model
model =
    Model ""



-- UPDATE


type Msg
    = Change String


update : Msg -> Model -> Model
update msg model =
    case msg of
        Change str ->
            { model | content = str }



-- VIEW


view : Model -> Html Msg
view model =
    div []
        [ input [ onInput Change, placeholder "Text to reverse" ] []
        , h1 [] [ text <| String.reverse model.content ]
        ]
