import { DocumentNode, GraphQLSchema } from 'graphql';
import { GraphQLSchemaModule, GraphQLResolverMap } from 'apollo-graphql';
declare type LegacySchemaModule = {
    typeDefs: DocumentNode | DocumentNode[];
    resolvers?: GraphQLResolverMap<any>;
};
export { GraphQLSchemaModule };
export declare function buildFederatedSchema(modulesOrSDL: (GraphQLSchemaModule | DocumentNode)[] | DocumentNode | LegacySchemaModule): GraphQLSchema;
//# sourceMappingURL=buildFederatedSchema.d.ts.map