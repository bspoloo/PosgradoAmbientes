<!DOCTYPE html>

<html lang="en" class="light-style layout-navbar-fixed layout-menu-fixed layout-compact" dir="ltr" data-theme="theme-default" data-assets-path="../../assets/" data-template="vertical-menu-template-starter">

<head>
    <title>@yield('title')</title>

    <x-metas>
    </x-metas>

    <x-links>
    </x-links>

    <x-scripts>
    </x-scripts>

</head>

<body>
    <div class="layout-wrapper layout-content-navbar">
        <div class="layout-container">
            
            <x-nav-bar>
            </x-nav-bar>

            <div class="layout-page">
                <nav class="layout-navbar container-xxl navbar navbar-expand-xl navbar-detached align-items-center bg-navbar-theme" id="layout-navbar">

                    <div class="layout-menu-toggle navbar-nav align-items-xl-center me-3 me-xl-0 d-xl-none">
                        <a class="nav-item nav-link px-0 me-xl-4" href="javascript:void(0)">
                            <i class="ti ti-menu-2 ti-sm"></i>
                        </a>
                    </div>

                    <div class="navbar-nav-right d-flex align-items-center" id="navbar-collapse">
                        <x-sun-icon>
                        </x-sun-icon>

                        <x-profile>
                        </x-profile>
                    </div>
                </nav>

                <div class="content-wrapper">

                    <div class="container-xxl flex-grow-1 container-p-y">
                        @yield('content')
                    </div>
                    <x-footer>
                    </x-footer>
                    <div class="content-backdrop fade"></div>
                </div>
            </div>
        </div>

        <div class="layout-overlay layout-menu-toggle"></div>
        <div class="drag-target"></div>
    </div>

    <x-scripts-foot>
    </x-scripts-foot>

</body>
</html>
