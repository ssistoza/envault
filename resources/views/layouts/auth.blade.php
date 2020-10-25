<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta http-equiv="X-UA-Compatible" content="ie=edge">
    <title>{{ config('app.name') }}</title>
    <meta name="description" content="">

    <link href="{{ asset('images/favicon.png', true) }}" rel="icon" type="image/png">

    <link href="{{ asset('css/app.css', true) }}" rel="stylesheet">
    @livewireStyles

    <script src="{{ asset('js/app.js', true) }}" defer></script>
    @livewireScripts
</head>

<body class="flex flex-col justify-center min-h-screen px-2 py-12 bg-gray-900 select-none sm:px-6">
<div class="sm:mx-auto sm:w-full sm:max-w-md">
    <img class="w-auto h-12 mx-auto" src="{{ asset('images/icon-white.svg', true) }}" alt="Envault logo" />
</div>

<div class="mt-8 sm:mx-auto sm:w-full sm:max-w-md">
    <div class="px-4 py-8 bg-gray-800 rounded-lg sm:px-10">
        @yield('content')
    </div>
</div>
</body>

</html>
