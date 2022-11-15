import { intersection } from "./intersection";
import type { Roles } from "../../models/accounts";

export function hasRoles(has: Roles[], needs: Roles[]) {
	return intersection(has, needs).length !== 0
}