<?php

namespace App\Http\Livewire;

use App\Models\LogEntry;
use Illuminate\Foundation\Auth\Access\AuthorizesRequests;
use Illuminate\Support\Str;
use Livewire\Component;
use Livewire\WithPagination;

class Log extends Component
{
    use AuthorizesRequests;
    use WithPagination;

    /**
     * @var string|null
     */
    public $action = null;

    /**
     * @var array
     */
    public $actions = [
        'Users' => [
            'user.created' => 'User added',
            'user.deleted' => 'User removed',
            'user.authenticated' => 'User signed in',
            'user.email.updated' => 'User email address updated',
            'user.name.updated' => 'User name updated',
            'user.role.updated' => 'User role updated',
        ],
        'Apps' => [
            'app.created' => 'App created',
            'app.deleted' => 'App deleted',
            'app.name.updated' => 'App name updated',
            'app.notifications.set-up' => 'App notifications set up',
            'app.notifications.update' => 'App notification settings updated',
            'app.collaborator.added' => 'Collaborator added',
            'app.collaborator.removed' => 'Collaborator removed',
            'app.collaborator.role.updated' => 'Collaborator role updated',
        ],
        'Variables' => [
            'app.variable.created' => 'Variable created',
            'app.variables.imported' => 'Variables imported',
            'app.variable.deleted' => 'Variable deleted',
            'app.variable.key.updated' => 'Variable key updated',
            'app.variable.value.updated' => 'Variable value updated',
        ],
    ];

    /**
     * @var int|null
     */
    public $appId = null;

    /**
     * @var int|null
     */
    public $userId = null;

    /**
     * @return string
     */
    public function paginationView()
    {
        return 'log.pagination';
    }

    /**
     * @param string $value
     * @return void
     */
    public function updatedAction($value)
    {
        // Reset app filter when an appless action is selected
        if (Str::before($value, '.') === 'user') {
            $this->appId = null;
        }

        $this->resetPage();
    }

    /**
     * @return void
     */
    public function updatedAppId()
    {
        $this->resetPage();
    }

    /**
     * @return void
     */
    public function updatedUserId()
    {
        $this->resetPage();
    }

    /**
     * @return \Illuminate\View\View
     */
    public function render()
    {
        $entries = LogEntry::query()
            ->whereNotNull('description')
            ->when(Str::contains($this->action, '.'), function ($query) {
                return $query->where([['action', Str::after($this->action, '.')], ['loggable_type', Str::before($this->action, '.')]]);
            })->when($this->appId && Str::before($this->action, '.') !== 'user', function ($query) {
                return $query->where([['loggable_id', $this->appId], ['loggable_type', 'app']]);
            })->when($this->userId, function ($query, $userId){
                return $query->where('user_id', $userId);
            });

        return view('log', [
            'entries' => $entries->orderBy('created_at', 'desc')->paginate(20),
        ]);
    }
}
