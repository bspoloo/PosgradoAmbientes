<div>
    <div>
        <div>
            The User Rol is: {!! session('data_session')['rol']->nombre !!}
        </div>
        <div>
            The User Name is: {!! session('data_session')['user']->nombre !!}
        </div>
        <div>
            <a href="/logout">Logout</a>
        </div>
    </div>
</div>