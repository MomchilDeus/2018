module Form exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Regex exposing (..)


main =
    Html.beginnerProgram { model = model, update = update, view = view }



-- MODEL


type alias Model =
    { name : String
    , password : String
    , passwordAgain : String
    , age : Int
    , submit : Bool
    }


model : Model
model =
    Model "" "" "" 0 False



-- UPDATE


type Msg
    = Name String
    | Password String
    | PasswordAgain String
    | Age String
    | Submit


update : Msg -> Model -> Model
update msg model =
    case msg of
        Name name ->
            { model | name = name, submit = False }

        Password pass ->
            { model | password = pass, submit = False }

        PasswordAgain passAgain ->
            { model | passwordAgain = passAgain, submit = False }

        Age int ->
            { model | age = Maybe.withDefault -1 <| Result.toMaybe <| String.toInt int, submit = False }

        Submit ->
            { model | submit = True }



-- VIEW


view : Model -> Html Msg
view model =
    div []
        [ input [ type_ "text", placeholder "Name", onInput Name ] []
        , input [ type_ "password", placeholder "Password", onInput Password ] []
        , input [ type_ "password", placeholder "Repeat Password", onInput PasswordAgain ] []
        , input [ type_ "text", placeholder "Age", onInput Age ] []
        , button [ onClick Submit ] [ text "Submit" ]
        , viewValidation model
        ]


viewValidation : Model -> Html Msg
viewValidation model =
    if model.submit then
        let
            ( color, message ) =
                checkInput model
        in
            div [ style [ ( "color", color ) ] ] [ text message ]
    else
        text ""


checkInput : Model -> ( String, String )
checkInput model =
    -- Check that password is at least 9 characters
    if String.length model.password > 8 then
        -- Check that passwords match
        if model.password == model.passwordAgain then
            -- At least 1 uppercase letter
            if contains (regex "[A-Z]") model.password == False then
                ( "red", "Password must contain at least 1 uppercase letter" )
                -- At least 1 lowercase letter
            else if contains (regex "[a-z]") model.password == False then
                ( "red", "Password must contain at least 1 lowercase letter" )
                -- At least 1 number
            else if contains (regex "[0-9]") model.password == False then
                ( "red", "Password must contain at least 1 number" )
                -- Age must be an integer > 0
            else if model.age < 1 then
                ( "red", "Age must be a positive number" )
            else
                ( "green", "Password OK" )
        else
            ( "red", "Passwords don't match" )
    else
        ( "red", "Password must be at least 9 characters" )
