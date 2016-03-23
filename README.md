##Class Clusters: A Solution For Dealing With Change

###Change
Every year new versions of iOS and MacOS become available with new APIs, changes to existing APIs, and a few bugs. With these changes comes the need to support two major releases at the same time - which can be an exercise in frustration. What was once clean code now has to support two different sets of functionality. An implementation that worked fine a few months ago may not now, and your application was written specifically for that implementation.

What if your application had instead been written to be flexible and easy to change? What if there was an easy way to do so that helped you deal with the inevitability of change?

Using abstractions to your advantage in Cocoa can make your application ready to meet the future, no matter what it may hold.

###What is an Abstract Class in Cocoa?

A class that provides no (or little) functionality on it’s own is called abstract. The primary purpose of an abstract class is to provide a well defined interface for subclasses to implement functionality.

In Objective-C the class interface is declared by the header (not a `Protocol`). An abstract class implements methods that serve as placeholders for primitive methods and throw an exception when invoked. In Objective-C exceptions are reserved for “programmer errors” rather than flow control - calling an abstract method constitutes a programmer error. Apple-provided abstract classes like `NSIncrementalStore` demonstrate this behavior.

###Using Abstract Classes in Cocoa

[Class clusters](https://developer.apple.com/library/mac/documentation/General/Conceptual/CocoaEncyclopedia/ClassClusters/ClassClusters.html#//apple_ref/doc/uid/TP40010810-CH4-SW75) are a common design pattern in Cocoa that combine elements of the Gang of Four patterns Abstract Factory and Facade. A class cluster provides a single public interface to a group of private implementations of that interface. It hides the complex implementation details behind the public interface.

Many of the classes in Foundation are class clusters, such as `NSString`, `NSNumber`, and `NSArray`. Each of these classes declares a public interface of primitive methods, with derived methods added as categories or extensions of the interface.

Typically a class cluster decides which concrete class implementation of the interface to use at runtime depending on the initialization method used. For example, when `-[NSNumber numberWithInteger:]` is invoked the class instance returned is not `NSNumber` but a private subclass that implements the `NSNumber` interface.

###Creating an Abstract Class

1.  Define the interface using primitive methods
2.  Write tests against the interface, looking for exceptions
3.  Create concrete implementations

First, design the interface of your class. In objective-c the interface is the set of publically exposed methods and variables - the header file. Typically primitive methods are the only ones that would access the storage of the class. Derived methods are constructed by calling primitive methods, and can be implemented as categories or extensions. Informal protocols such as `NSCopying` can also often be implemented in categories. Doing so makes creating subclasses easier and keeps concerns separated.

In the implementation of the interface, provide placeholders for each of the primitive methods. Properties should be declared as `@dynamic` as implementations should be provided by subclasses. Methods should return an exception or invoke `doesNotRecognizeSelector`. Apple’s abstract classes invoke `NSInvalidAbstractInvocation()` or `NSSubclassResponsibility()` to throw a specific `NSInvalidArgumentException` or `NSInternalInconsistencyException`. Unfortunately this is not public, however the basic functionality has been replicated [here](https://github.com/quellish/FoundationRaise).

Once the interface is defined, write unit tests that exercise it. Tests that check wether calling these methods throws exceptions are now valuable, as this is exactly what the abstract class will do at this point. These tests should fail at this point.

###Making A Class Cluster

With the abstract class and tests in place you are now in a position to decide how the class cluster itself should be implemented. We will look at two different approaches: using a custom initializer and overriding allocation.

####Custom Initialization

Implement the designated initializer to choose which concrete class to return. For example, a class cluster that returns a different implementation based on the availability of the Contacts API might look like this:

    - (instancetype) initWithFirstName:(NSString *)firstName {
        if (NSClassFromString(@"CNContactStore") != nil){
            return (id)[[ContactsPerson alloc] initWithFirstName:firstName];
        } else {
            return (id)[[AddressBookPerson alloc] initWithFirstName:firstName];
        }
    }


The calling graph looks like this:

![custom initializer example](https://41.media.tumblr.com/6920c219029d1ccbc1405b631aeee362/tumblr_inline_nvf40zMSWZ1r6lwso_540.png)

This is pretty straightforward, but requires the abstract class to be aware of it’s own concrete subclasses. Generally that is something to avoid, and as subclasses are added or changed it can get more difficult to troubleshoot and maintain.

    ####Overriding allocation

    An alternative is to instead override an allocation method on the abstract class to return a placeholder object. This object’s only responsibility is to serve as a factory for the concrete superclasses. It is the only class that has to be aware that they exist. This allows for good separation of responsibilities and preserves encapsulation. The abstract class still has to be aware of the placeholder class, but that never changes.

Overiding `+allocWithZone:` looks like this:

    + (id) allocWithZone:(struct _NSZone *)__unused zone {
        id      result              = nil;
        Class   clusterClass        = NSClassFromString(@"AbstractClass");
        Class   placeholderClass    = NSClassFromString(@"PlaceholderClass");

        // Don't get into an infinite loop.
        if(self == clusterClass){
            result = [placeholderClass alloc];
        } else {
            result = [super allocWithZone:zone];
        }
        return result;
    }

This allows any allocation of the abstract class to return the placeholder class, and subclasses will correctly return themselves.
    Because the placeholder class has no internal state of it’s own, as an optimization it’s safe to only ever have one of them:

    + (id) allocWithZone:(struct _NSZone *)__unused zone {
        id      result              = nil;
        Class   clusterClass        = NSClassFromString(@"AbstractClass");
        Class   placeholderClass    = nil;

        // Don't get into an infinite loop.
        if(self == clusterClass){
            static dispatch_once_t  onceToken    = 0L;
            static id               placeholder  = NULL;

            placeholderClass = NSClassFromString(@"PlaceholderClass");
            dispatch_once(&onceToken, ^{
                    placeholder = [placeholderClass alloc];
            });
            result = placeholder;
        } else {
            result = [super allocWithZone:zone];
        }
        return result;
    }


At that point you are ready to implement the placeholder class, which will only implement the designated initializer - just like the custom initialization example above:

    - (instancetype) initWithFirstName:(NSString *)firstName {
        if (NSClassFromString(@"CNContactStore") != nil){
            return (id)[[ContactsPerson alloc] initWithFirstName:firstName];
        } else {
            return (id)[[AddressBookPerson alloc] initWithFirstName:firstName];
        }
    }

The call graph looks like this:

![allocWithZone example](https://41.media.tumblr.com/099355001f6f80e5aadedb165e9dda1a/tumblr_inline_nvf41fE1q91r6lwso_540.png)

This is how some of the Foundation class clusters like `NSNumber` and `NSString` are implemented. A well implemented class cluster expresses all of the [SOLID](http://butunclebob.com/ArticleS.UncleBob.PrinciplesOfOod) principles of object oriented design as well as

Now the concrete classes can be implemented to start passing the tests. Using the class cluster pattern makes it very easy to change things quickly without breaking functionality in anything that depends on the abstract interface. You could, for example, add a Facebook contact implementation easily, or at some point remove the implementation based on the AddressBook API.

[Examples are available on GitHub](https://github.com/quellish/ClassClustersExamples)
