CFSSpringTableView
===============


This UITableView Subclass makes your table view 
looks like its cells are connected to each other by springs.
It uses UIDynamics classes, so you can use only if your project
does NOT support iOS version < 7.0

Demo
http://youtu.be/HogSEquruzs

*Note
######You must call the instance method |prepareCellForShow:(UITableViewCell)cell| on your delegate implementation of |tableView:willShow order to get the spring effect. Here is an example:

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.tableView prepareCellForShow:cell];
}
