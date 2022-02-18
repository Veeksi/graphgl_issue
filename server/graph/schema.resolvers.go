package graph

// This file will be automatically regenerated based on the schema, any resolver implementations
// will be copied through when generating and any unknown code will be moved to the end.

import (
	"context"
	"my/graphql/api/graph/generated"
	"my/graphql/api/graph/model"
	"strconv"
)

func (r *mutationResolver) CreateTodo(ctx context.Context, input model.NewTodo) (*model.Todo, error) {
	id := strconv.Itoa(len(r.todos))

        // CREATE A NEW TODO
        todo := &model.Todo{
                Text:   input.Text,
                ID:     id,
                User: &model.User{ID: input.UserID, Name: "user " + input.UserID},
        }
        // ADD THE TODO TO THE TODOS ARRAY
        r.todos = append(r.todos, todo)
        // RETURN THE TODO
        return todo, nil
}

func (r *queryResolver) Todos(ctx context.Context) ([]*model.Todo, error) {
	// RETURN ALL THE TODOS
	return r.todos, nil
}

// Mutation returns generated.MutationResolver implementation.
func (r *Resolver) Mutation() generated.MutationResolver { return &mutationResolver{r} }

// Query returns generated.QueryResolver implementation.
func (r *Resolver) Query() generated.QueryResolver { return &queryResolver{r} }

type mutationResolver struct{ *Resolver }
type queryResolver struct{ *Resolver }
