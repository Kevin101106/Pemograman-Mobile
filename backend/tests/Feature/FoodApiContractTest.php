<?php

namespace Tests\Feature;

use App\Models\User;
use Illuminate\Foundation\Testing\RefreshDatabase;
use PHPUnit\Framework\Attributes\DataProvider;
use Tests\TestCase;

class FoodApiContractTest extends TestCase
{
    use RefreshDatabase;

    private function validFoodData(array $overrides = []): array
    {
        return array_merge([
            'name' => 'Test Food',
            'category' => 'Vegetable',
            'quantity' => 2,
            'stored_date' => '2026-11-20',
            'use_by_date' => '2026-11-25',
            'location' => 'Refrigerator',
        ], $overrides);
    }

    private function authenticatedUser(): User
    {
        $user = User::factory()->create();
        $this->actingAs($user);

        return $user;
    }

    public static function foodApiScenarios(): array
    {
        $scenarios = [];

        for ($i = 1; $i <= 20; $i++) {
            $scenarios["index_returns_{$i}_foods"] = [[
                'type' => 'index',
                'value' => $i,
            ]];
        }

        for ($i = 1; $i <= 16; $i++) {
            $scenarios["show_returns_food_{$i}"] = [[
                'type' => 'show',
                'value' => $i,
            ]];
        }

        $updates = [
            ['name', 'Apple'],
            ['name', 'Banana'],
            ['name', 'Carrot'],
            ['name', 'Potato'],
            ['name', 'Orange'],
            ['category', 'Fruit'],
            ['category', 'Dairy'],
            ['category', 'Meat'],
            ['quantity', 1],
            ['quantity', 5],
            ['quantity', 100],
            ['location', 'Freezer'],
            ['location', 'Pantry'],
            ['stored_date', '2026-11-21'],
            ['use_by_date', '2026-11-26'],
        ];

        foreach ($updates as $i => $update) {
            $scenarios['update_food_' . ($i + 1)] = [[
                'type' => 'update',
                'field' => $update[0],
                'value' => $update[1],
            ]];
        }

        for ($i = 1; $i <= 15; $i++) {
            $scenarios["delete_food_{$i}"] = [[
                'type' => 'delete',
                'value' => $i,
            ]];
        }

        return $scenarios;
    }

    #[DataProvider('foodApiScenarios')]
    public function test_food_api_contract_scenarios(array $scenario): void
    {
        $user = $this->authenticatedUser();

        if ($scenario['type'] === 'index') {
            $count = $scenario['value'];

            for ($i = 1; $i <= $count; $i++) {
                $user->foods()->create(
                    $this->validFoodData([
                        'name' => 'Food ' . $i,
                    ])
                );
            }

            $this->getJson('/api/foods')
                ->assertOk()
                ->assertJsonCount($count);

            return;
        }

        if ($scenario['type'] === 'show') {
            $name = 'Food ' . $scenario['value'];

            $food = $user->foods()->create(
                $this->validFoodData(['name' => $name])
            );

            $this->getJson('/api/foods/' . $food->id)
                ->assertOk()
                ->assertJsonPath('name', $name);

            return;
        }

        if ($scenario['type'] === 'update') {
            $field = $scenario['field'];
            $value = $scenario['value'];

            $food = $user->foods()->create(
                $this->validFoodData()
            );

            $this->patchJson('/api/foods/' . $food->id, [
                $field => $value,
            ])
                ->assertOk()
                ->assertJsonPath('data.' . $field, $value);

            $this->assertDatabaseHas('foods', [
                'id' => $food->id,
                $field => $value,
            ]);

            return;
        }

        if ($scenario['type'] === 'delete') {
            $food = $user->foods()->create(
                $this->validFoodData([
                    'name' => 'Food ' . $scenario['value'],
                ])
            );

            $this->deleteJson('/api/foods/' . $food->id)
                ->assertOk()
                ->assertJson([
                    'message' => 'Makanan berhasil dihapus',
                ]);

            $this->assertDatabaseMissing('foods', [
                'id' => $food->id,
            ]);

            return;
        }

        $this->fail('Unknown food API test scenario.');
    }
}
