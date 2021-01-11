pub mod digraph;
pub mod simple;

use crate::perm::Permutation;
use crate::vole::backtracking::Backtrack;
use crate::vole::trace;

pub trait Refiner<State: super::state::State>: Backtrack {
    // A human readable name for the refiners
    fn name(&self) -> String;

    /// Check if this refiner represents a group (as opposed to a coset)
    fn is_group(&self) -> bool;

    /// Check is [p] is in group/coset represented by the refiner
    fn check(&self, p: &Permutation) -> bool;

    fn refine_begin_left(&mut self, _: &mut State) -> trace::Result<()> {
        Ok(())
    }

    fn refine_fixed_points_left(&mut self, _: &mut State) -> trace::Result<()> {
        Ok(())
    }

    fn refine_changed_cells_left(&mut self, _: &mut State) -> trace::Result<()> {
        Ok(())
    }

    fn refine_begin_right(&mut self, s: &mut State) -> trace::Result<()> {
        self.refine_begin_left(s)
    }

    fn refine_fixed_points_right(&mut self, s: &mut State) -> trace::Result<()> {
        self.refine_fixed_points_left(s)
    }

    fn refine_changed_cells_right(&mut self, s: &mut State) -> trace::Result<()> {
        self.refine_changed_cells_left(s)
    }
}
