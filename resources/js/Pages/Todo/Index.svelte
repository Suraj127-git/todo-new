<script>
    import { router } from '@inertiajs/svelte'
    console.log('Index.svelte loaded');
   
    export let todos = [];
    let newTodo = '';
   
    const addTodo = () => {
        router.post('/todo', { title: newTodo });
        newTodo = ''; // Clear input after submission
    };
   
    const toggleComplete = (todo) => {
        router.post(`/todo/${todo.id}`, { completed: !todo.completed });
    };
   
    const deleteTodo = (id) => {
        router.post(`/todo/${id}`);
    };
</script>

<div class="todo-app p-6 bg-gray-100 min-h-screen">
    <div class="max-w-xl mx-auto bg-white rounded-lg shadow-md p-6">
        <h1 class="text-2xl font-bold text-gray-800 mb-6">Todo List</h1>
        <form on:submit|preventDefault={addTodo} class="flex items-center gap-2 mb-6">
            <input
                type="text"
                bind:value={newTodo}
                placeholder="New Task"
                class="w-full p-2 border border-gray-300 rounded-md focus:outline-none focus:ring-2 focus:ring-blue-400"
            />
            <button
                type="submit"
                class="bg-blue-500 text-white px-4 py-2 rounded-md hover:bg-blue-600 transition"
            >
                Add
            </button>
        </form>
        <ul class="space-y-4">
            {#each todos as todo}
                <li class="flex items-center justify-between bg-gray-50 p-4 rounded-lg shadow">
                    <label class="flex items-center gap-2">
                        <input
                            type="checkbox"
                            checked={todo.completed}
                            on:change={() => toggleComplete(todo)}
                            class="h-4 w-4 text-blue-600 focus:ring-blue-400 border-gray-300 rounded"
                        />
                        <span class="text-gray-700 {todo.completed ? 'line-through' : ''}">{todo.title}</span>
                    </label>
                    <button
                        on:click={() => deleteTodo(todo.id)}
                        class="bg-red-500 text-white px-3 py-1 rounded-md hover:bg-red-600 transition"
                    >
                        Delete
                    </button>
                </li>
            {/each}
        </ul>
    </div>
</div>