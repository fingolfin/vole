use std::sync::Arc;

use super::Refiner;
use super::{super::domain_state::DomainState, Side};
use crate::perm::Permutation;
use crate::vole::trace;
use crate::{datastructures::digraph::Digraph, vole::backtracking::Backtrack};

pub struct DigraphTransporter {
    digraph_left: Arc<Digraph>,
    digraph_right: Arc<Digraph>,
}

impl DigraphTransporter {
    pub fn new_stabilizer(digraph: Arc<Digraph>) -> Self {
        Self::new_transporter(digraph.clone(), digraph)
    }

    pub fn new_transporter(digraph_left: Arc<Digraph>, digraph_right: Arc<Digraph>) -> Self {
        Self {
            digraph_left,
            digraph_right,
        }
    }

    fn image(&self, p: &Permutation) -> Digraph {
        &(*self.digraph_left) ^ p
    }

    fn compare(&self, lhs: &Digraph, rhs: &Digraph) -> std::cmp::Ordering {
        lhs.cmp(rhs)
    }
}

impl Refiner for DigraphTransporter {
    gen_any_image_compare!(Digraph);

    fn name(&self) -> String {
        if self.is_group() {
            format!("DigraphTransporter of {:?}", self.digraph_left)
        } else {
            format!(
                "DigraphTransporter of {:?} -> {:?}",
                self.digraph_left, self.digraph_right
            )
        }
    }

    fn check(&self, p: &Permutation) -> bool {
        &(*self.digraph_left) ^ p == *self.digraph_right
    }

    fn refine_begin(&mut self, state: &mut DomainState, side: Side) -> trace::Result<()> {
        state.add_arc_graph(match side {
            Side::Left => &self.digraph_left,
            Side::Right => &self.digraph_right,
        });

        Ok(())
    }

    fn is_group(&self) -> bool {
        Arc::ptr_eq(&self.digraph_left, &self.digraph_right)
    }
}

impl Backtrack for DigraphTransporter {
    fn save_state(&mut self) {}
    fn restore_state(&mut self) {}
}
