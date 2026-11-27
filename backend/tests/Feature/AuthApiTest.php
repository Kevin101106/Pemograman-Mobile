<?php

namespace Tests\Feature;

use App\Models\User;
use Illuminate\Foundation\Testing\RefreshDatabase;
use Tests\TestCase;

class AuthApiTest extends TestCase
{
    use RefreshDatabase;

    public function test_user_can_register_successfully(): void
    {
        $response = $this->postJson('/api/register', [
            'name' => 'Kevin',
            'email' => 'kevin@example.com',
            'password' => 'password123',
            'password_confirmation' => 'password123',
        ]);

        $response->assertCreated()
            ->assertJsonStructure(['message', 'user', 'token']);

        $this->assertDatabaseHas('users', [
            'email' => 'kevin@example.com',
        ]);
    }

    public function test_registration_requires_name(): void
    {
        $response = $this->postJson('/api/register', [
            'email' => 'kevin@example.com',
            'password' => 'password123',
            'password_confirmation' => 'password123',
        ]);

        $response->assertUnprocessable()
            ->assertJsonValidationErrors('name');
    }

    public function test_registration_requires_email(): void
    {
        $response = $this->postJson('/api/register', [
            'name' => 'Kevin',
            'password' => 'password123',
            'password_confirmation' => 'password123',
        ]);

        $response->assertUnprocessable()
            ->assertJsonValidationErrors('email');
    }

    public function test_registration_requires_valid_email(): void
    {
        $response = $this->postJson('/api/register', [
            'name' => 'Kevin',
            'email' => 'invalid-email',
            'password' => 'password123',
            'password_confirmation' => 'password123',
        ]);

        $response->assertUnprocessable()
            ->assertJsonValidationErrors('email');
    }

    public function test_registration_rejects_duplicate_email(): void
    {
        User::factory()->create([
            'email' => 'kevin@example.com',
        ]);

        $response = $this->postJson('/api/register', [
            'name' => 'Kevin',
            'email' => 'kevin@example.com',
            'password' => 'password123',
            'password_confirmation' => 'password123',
        ]);

        $response->assertUnprocessable()
            ->assertJsonValidationErrors('email');
    }

    public function test_registration_requires_password(): void
    {
        $response = $this->postJson('/api/register', [
            'name' => 'Kevin',
            'email' => 'kevin@example.com',
        ]);

        $response->assertUnprocessable()
            ->assertJsonValidationErrors('password');
    }

    public function test_registration_rejects_short_password(): void
    {
        $response = $this->postJson('/api/register', [
            'name' => 'Kevin',
            'email' => 'kevin@example.com',
            'password' => '123',
            'password_confirmation' => '123',
        ]);

        $response->assertUnprocessable()
            ->assertJsonValidationErrors('password');
    }

    public function test_registration_requires_password_confirmation(): void
    {
        $response = $this->postJson('/api/register', [
            'name' => 'Kevin',
            'email' => 'kevin@example.com',
            'password' => 'password123',
            'password_confirmation' => 'different123',
        ]);

        $response->assertUnprocessable()
            ->assertJsonValidationErrors('password');
    }

    public function test_registration_rejects_name_longer_than_255_characters(): void
    {
        $response = $this->postJson('/api/register', [
            'name' => str_repeat('A', 256),
            'email' => 'kevin@example.com',
            'password' => 'password123',
            'password_confirmation' => 'password123',
        ]);

        $response->assertUnprocessable()
            ->assertJsonValidationErrors('name');
    }

    public function test_login_successfully(): void
    {
        $user = User::factory()->create([
            'email' => 'kevin@example.com',
            'password' => 'password123',
        ]);

        $response = $this->postJson('/api/login', [
            'email' => 'kevin@example.com',
            'password' => 'password123',
        ]);

        $response->assertOk()
            ->assertJsonStructure(['message', 'user', 'token']);
    }

    public function test_login_rejects_wrong_password(): void
    {
        User::factory()->create([
            'email' => 'kevin@example.com',
            'password' => 'password123',
        ]);

        $response = $this->postJson('/api/login', [
            'email' => 'kevin@example.com',
            'password' => 'wrongpassword',
        ]);

        $response->assertUnauthorized();
    }

    public function test_login_rejects_unknown_email(): void
    {
        $response = $this->postJson('/api/login', [
            'email' => 'unknown@example.com',
            'password' => 'password123',
        ]);

        $response->assertUnauthorized();
    }

    public function test_login_requires_email(): void
    {
        $response = $this->postJson('/api/login', [
            'password' => 'password123',
        ]);

        $response->assertUnprocessable()
            ->assertJsonValidationErrors('email');
    }

    public function test_login_requires_valid_email(): void
    {
        $response = $this->postJson('/api/login', [
            'email' => 'invalid-email',
            'password' => 'password123',
        ]);

        $response->assertUnprocessable()
            ->assertJsonValidationErrors('email');
    }

    public function test_login_requires_password(): void
    {
        $response = $this->postJson('/api/login', [
            'email' => 'kevin@example.com',
        ]);

        $response->assertUnprocessable()
            ->assertJsonValidationErrors('password');
    }

    public function test_authenticated_user_can_access_profile(): void
    {
        $user = User::factory()->create();

        $response = $this->actingAs($user, 'sanctum')
            ->getJson('/api/user');

        $response->assertOk()
            ->assertJsonPath('id', $user->id);
    }

    public function test_user_can_logout_successfully(): void
    {
        $user = User::factory()->create();

        $token = $user->createToken('test-token')->plainTextToken;

        $response = $this->withToken($token)
            ->postJson('/api/logout');

        $response->assertOk()
            ->assertJson(['message' => 'Logout berhasil']);

        $this->assertDatabaseCount('personal_access_tokens', 0);
    }
}
